pipeline {
    agent any

    environment {
        TF_VAR_access_key = credentials('aws-access-key-id')
        TF_VAR_secret_key = credentials('aws-secret-access-key')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('elasticsearch-terraform') {
                    sh 'pwd'
                    sh 'ls -la'
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Wait for EC2 Ready') {
            steps {
                echo 'Waiting for EC2 instances to be ready...'
                sleep time: 60, unit: 'SECONDS'
            }
        }

        stage('Run Ansible Role') {
            steps {
                sh 'ansible-playbook -i inventory install.yml'
            }
        }
    }

    post {
        always {
            echo 'Job Completed'
        }
    }
}
