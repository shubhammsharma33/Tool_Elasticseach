pipeline {
    agent any
    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git 'https://github.com/shubhammsharma33/Tool_Elasticseach.git'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Wait for EC2 Ready') {
            steps {
                echo 'Sleeping to let EC2 initialize...'
                sleep time: 60, unit: 'SECONDS'
            }
        }

        stage('Run Ansible Role') {
            steps {
                dir('ansible') {
                    sshagent(credentials: ['new-key']) {
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
