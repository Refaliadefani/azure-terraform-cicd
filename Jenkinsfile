pipeline {
    agent {
        kubernetes {
            // Mendefinisikan Pod sementara yang berisi container Terraform
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: terraform
    image: hashicorp/terraform:1.5.7
    command:
    - cat
    tty: true
'''
        }
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Mengambil source code dari GitHub
                checkout scm 
            }
        }

        stage('Terraform Init') {
            steps {
                // Menjalankan perintah di dalam container 'terraform'
                container('terraform') {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                container('terraform') {
                    // Membuat file rencana (plan)
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                container('terraform') {
                    // Eksekusi perubahan ke Azure
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline berhasil diselesaikan. Infrastruktur telah diperbarui."
        }
        failure {
            echo "Pipeline gagal. Silakan periksa log di Console Output."
        }
    }
}
