pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('mytool/elasticsearch-terraform') {
                    sh 'echo "Current Directory: $(pwd)"'
                    sh 'ls -la'
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Wait for EC2 Ready') {
            steps {
                echo 'Sleeping to let EC2 initialize...'
                sleep(time: 60, unit: 'SECONDS')
            }
        }

        stage('Run Ansible Role') {
            steps {
                dir('mytool') {
                    sshagent(['ubuntu']) {
                        sh 'ansible-playbook -i inventory install.yml'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Job Completed'
        }
    }
}
