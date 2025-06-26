pipeline {
    agent any

    stages {
        stage('Terraform Apply') {
            steps {
                dir('mytool/elasticsearch-terraform') {
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
