pipeline {
    agent any

    // GANTI JADI 'terraform-latest' BIAR SI JENKINS GAK BINGUNG LAGI! ✨
    tools {
        terraform 'terraform-latest' 
    }

    stages {
        stage('Pull Code') {
            steps {
                checkout scm 
                echo "Barangnya udah sampe, Bestie! 💅"
            }
        }

        stage('Terraform Init') {
            steps {
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
                // Pastiin use_msi = true ada di main.tf ya!
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        success {
            echo "SLAY! Akhirnya tembus Azure! 🚀🔥"
        }
        failure {
            echo "Yah, merah lagi! Cek Console Output-nya, Cong! 🚩"
        }
    }
}