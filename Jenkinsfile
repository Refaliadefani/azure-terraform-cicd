pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: terraform
    image: hashicorp/terraform:1.5.7
    command: ["cat"]
    tty: true
'''
        }
    }

    environment {
        // Jenkins otomatis ambil ID asli dari Credentials dan disembunyiin pake bintang (****)
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_USE_MSI         = 'true'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm 
            }
        }

        stage('Terraform Init') {
            steps {
                container('terraform') {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                container('terraform') {
                    // Terraform otomatis baca variabel ARM_SUBSCRIPTION_ID dari environment
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                container('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            sh 'rm -f tfplan'
        }
    }
}
