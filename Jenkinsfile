pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm 
            }
        }

        stage('Setup Terraform') {
            steps {
                sh '''
                    # Kita pake versi .tar.gz supaya gak butuh unzip! ✨
                    if [ ! -f "terraform" ]; then
                        echo "Lagi narik Terraform versi tar.gz... 🏎️💨"
                        # Pakai versi 0.11.15 karena HashiCorp menyediakan format tar.gz yang stabil
                        curl -Lo terraform.tar.gz https://releases.hashicorp.com/terraform/0.11.15/terraform_0.11.15_linux_amd64.tar.gz
                        
                        # Extract pake tar (Ini pasti ada di semua Linux)
                        tar -xzf terraform.tar.gz
                        rm terraform.tar.gz
                    fi
                    
                    chmod +x terraform
                    ./terraform version
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh './terraform init -input=false'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh './terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh './terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            // Bersihin file plan biar gak nyampah
            sh 'rm -f tfplan'
        }
    }
}
