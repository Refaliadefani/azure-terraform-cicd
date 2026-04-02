pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                // Mengambil kode dari GitHub
                checkout scm 
            }
        }

        stage('Setup Terraform') {
            steps {
                sh '''
                    # Download Terraform versi 1.5.7 (Linux 64-bit)
                    # Menggunakan curl karena lebih stabil di lingkungan CI/CD
                    curl -LO https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
                    
                    # Unzip file. Jika unzip tidak ada, gunakan python untuk extract
                    unzip terraform_1.5.7_linux_amd64.zip || python3 -m zipfile -e terraform_1.5.7_linux_amd64.zip .
                    
                    # Memberikan izin eksekusi pada binary terraform
                    chmod +x terraform
                    
                    # Verifikasi apakah terraform bisa dijalankan
                    ./terraform version
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                // Menjalankan inisialisasi menggunakan binary lokal (./)
                sh './terraform init -input=false'
            }
        }

        stage('Terraform Plan') {
            steps {
                // Membuat rencana perubahan infrastruktur
                sh './terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Eksekusi perubahan ke Azure secara otomatis
                sh './terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            // Menghapus file plan dan zip agar workspace tetap bersih
            sh 'rm -f tfplan terraform_1.5.7_linux_amd64.zip'
        }
    }
}
