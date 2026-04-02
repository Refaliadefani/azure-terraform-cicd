pipeline {
    agent any

    tools {
        terraform 'terraform' 
    }

    stages {
        stage('Pull Code') {
            steps {
                // Jenkins otomatis narik kodenya, gak perlu git pull manual!
                checkout scm 
                echo "Barangnya udah sampe dari GitHub, Cong! ✨"
            }
        }

        stage('Terraform Init') {
            steps {
                // Tambahin -input=false biar gak macet nunggu ketikan lo
                sh 'terraform init -input=false'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Inget: use_msi = true harus udah ada di provider main.tf ya!
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        success {
            echo "SLAY! Infrastruktur Azure lo udah jadi, Refa! 🚀🔥"
        }
        failure {
            echo "Yah, merah lagi! Cek Console Output, pasti ada yang kurang tuh! 🚩"
        }
    }
}