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
                    # Karena unzip & python tidak ada, kita download binary-nya saja
                    # Kita gunakan versi 0.12.31 karena tersedia link binary langsung 
                    # Jika ingin versi 1.x, pastikan link-nya tepat
                    
                    if [ ! -f "terraform" ]; then
                        echo "Downloading terraform binary..."
                        # Mengambil binary yang sudah diekstrak (pake link versi amd64)
                        curl -Lo terraform https://raw.githubusercontent.com/Refaliadefani/azure-terraform-cicd/main/terraform || echo "Gagal download"
                        
                        # Jika link di atas tidak jalan, kita gunakan cara alternatif:
                        # Mendownload zip lalu kita akali pake 'jar' (biasanya ada di Jenkins)
                        if [ ! -f "terraform" ]; then
                           curl -LO https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
                           # Jenkins biasanya punya Java, jadi kita bisa pakai 'jar' untuk unzip
                           jar xf terraform_1.5.7_linux_amd64.zip
                        fi
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
            sh 'rm -f tfplan terraform_1.5.7_linux_amd64.zip'
        }
    }
}
