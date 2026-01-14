 pipeline {
     agent any
     stages {
         stage('Lint') {
             steps {
                 sh 'flake8 app.py'
             }
         }
         stage('Format') {
             steps {
                 sh 'black --check app.py'
             }
         }
         stage('Build') {
             steps {
                 sh 'docker build --network host -t <dockerhub-username>/<repo-name>:0.0.1 .'
                 sh 'docker push <dockerhub-username>/<repo-name>:0.0.1'
             }
         }
     }
 }

