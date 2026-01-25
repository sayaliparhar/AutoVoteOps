pipeline {
    agent {
        label 'K8s-Master'
    }

    environment {
        NAMESPACE = 'autovote'
    }

    parameters {
        choice(name: 'DEPLOYMENT_NAME',
               choices: ['frontend', 'backend', 'all'],
               description: 'Which Deployment to RollBack')
        string(name: 'REVISION', defaultValue: '0', description: 'Revision Number to Rollback (0 = previous)')
    }

    stages {
        stage('Confirmation') {
            steps {
                echo "Rollout Initiated"
                echo "Deployment: ${params.DEPLOYMENT_NAME}"
                echo "Revision: ${params.REVISION}"
            }
        }

        stage('Check Rollout History') {
            steps {
                echo "Checking Deployment History"
                script {
                    if (params.DEPLOYMENT_NAME == 'all') {
                        sh """
                          echo "Frontend Deployment History"
                          kubectl rollout history deployment frontend -n ${NAMESPACE}
                          echo "Backend Deployment History"
                          kubectl rollout history deployment backend -n ${NAMESPACE}
                        """
                    } else {
                        sh "kubectl rollout history deployment ${params.DEPLOYMENT_NAME} -n ${NAMESPACE}"
                    }
                }
            }
        }

        stage('RollBack Deployment') {
            steps {
                echo "Rolling Back Deployment"
                script {
                    if (params.DEPLOYMENT_NAME == 'all') {
                        sh """
                          echo "Rolling Back Frontend"
                          kubectl rollout undo deployment frontend -n ${NAMESPACE} --to-revision=${params.REVISION}
                          echo "Rolling Back Backend"
                          kubectl rollout undo deployment backend -n ${NAMESPACE} --to-revision=${params.REVISION}
                        """
                    } else {
                        sh "kubectl rollout undo deployment ${params.DEPLOYMENT_NAME} -n ${NAMESPACE} --to-revision=${params.REVISION}"
                    }
                }
            }
        }

        stage('Wait For RollBack') {
            steps {
                echo "Waiting For RollBack to Complete"
                script {
                    if (params.DEPLOYMENT_NAME == 'all') {
                        sh """
                          kubectl rollout status deployment frontend -n ${NAMESPACE} --timeout=5m
                          kubectl rollout status deployment backend -n ${NAMESPACE} --timeout=5m
                        """
                    } else {
                        sh "kubectl rollout status deployment ${params.DEPLOYMENT_NAME} -n ${NAMESPACE} --timeout=5m"
                    }
                }
                echo "RollBack Completed"
            }
        }

        stage('Verify Rollback') {
            steps {
                echo "Verifying Rollback"
                sh """
                  echo "Deployment Status"
                  kubectl get deployments -n ${NAMESPACE}
                  echo "Current Pod Status"
                  kubectl get pods -n ${NAMESPACE}
                """
            }
        }
    }
    post {
        success {
            echo "Rollback Success"
            script {
              def rollbackInfo = """
              =====================================
                 Rollback Completed Successfully
              =====================================
              Deployment : ${params.DEPLOYMENT_NAME}
              Revision : ${params.REVISION}
              =====================================
              """
              echo rollbackInfo
            }
        }

        failure {
            echo "RollBack Failed" 
            sh """
              kubectl get events -n ${NAMESPACE} --sort-by='.lastTimestamp' | tail -30
            """
        }

        always {
            sh "kubectl get all -n ${NAMESPACE}"
        }
    }
}