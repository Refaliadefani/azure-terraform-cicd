pipeline {
    agent any
    stages {
        stage('Pull Code') {
            steps {
                // Ini pengganti git pull manual, Jenkins otomatis narik kodenya
                checkout scm 
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        stage('Terraform Apply') {
            steps {
                // Gak pake SP kan? Pastiin use_msi = true udah ada di main.tf ya!
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}