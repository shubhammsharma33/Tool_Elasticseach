pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        ANSIBLE_HOST_KEY_CHECKING = 'False'    
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

        stage('Install Ansible Role') {
            steps {
                sh 'ansible-galaxy install -r requirements.yml -p roles/ --force'
            }
        }
        
        stage('Run Ansible Playbook') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu-ssh-key', keyFileVariable: 'KEY')]) {
                    sh '''
                        export ANSIBLE_HOST_KEY_CHECKING=False 
                        ansible-playbook -i inventory --private-key=$KEY install.yml
                    '''    
                }
            }
        }
    
    post {
        always {
            echo ' Job Completed'
        }
    }
}
