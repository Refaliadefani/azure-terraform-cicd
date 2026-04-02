pipeline {
    agent any

    stages {
        stage('Step 1: Pull Code') {
            steps {
                checkout scm 
                echo "Barangnya aman, Ref! ✨"
            }
        }

        stage('Step 2: Install & Init Terraform') {
            steps {
                sh '''
                    if ! command -v terraform &> /dev/null; then
                        echo "Terraform gak ada, gue instalin bentar ya, Bestie..."
                        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
                        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
                        sudo apt-get update && sudo apt-get install terraform -y
                    fi
                    terraform init -input=false
                '''
            }
        }

        stage('Step 3: Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Step 4: Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        success { echo "AKHIRNYA HIJAU JUGA! 🚀🔥💅" }
        failure { echo "Cek lagi! Dikit lagi tembus ini! 🚩" }
    }
}
