pipeline {
    agent any

    // tools { 
    //     maven 'my-maven' 
    //     jdk 'my-jdk' 
    // }

    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
        NAME = 'DINHLE'
    }
    stages {

        stage('Initialize') {
            environment {
                NAME = 'HOANG'
            }
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                    echo "$BRANCH_NAME"
                    echo "$NODE_NAME"
                    echo "$NAME"
                ''' 
            }
        }
        stage('Build in maven') {
            agent {
                docker {
                    image 'maven:latest'
                    reuseNode true
                }
            }
            steps {
                // def X = "abc"
                // def Y = 'mnq'
                // echo '$X'
                // echo "$Y"
                // echo '${X}'
                // echo "${Y}"

                // echo "${params.Greeting} World!"
                // sh 'echo $NAME'
                // sh "echo ${NAME}"
                echo 'Building nginx image..'
                sh 'mvn --version'
                sh 'pwd'
                sh 'ls -la'
                sh 'mvn clean package -Dmaven.test.failure.ignore=true'
                sh 'docker build -t hoangledinh65/springboot-image:1.0 .'
                
            }
        }

        stage('Package to docker image') {
            steps {
                sh 'echo abc'
            }
        }
        stage('Pushing image') {
            steps {
                echo 'Start pushing.. with credential'
                sh 'echo $DOCKERHUB_CREDENTIALS'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push hoangledinh65/springboot-image:1.0'
                
            }
        }
        stage('Deploying and Cleaning') {
            steps {
                echo 'Deploying and cleaning'
                sh 'docker image rm hoangledinh65/springboot-image:1.0 || echo "this image does not exist" '
                sh 'docker container stop my-demo-springboot || echo "this container does not exist" '
                sh 'docker network create jenkins || echo "this network exists"'
                sh 'echo y | docker container prune '
                sh 'echo y | docker image prune'
                sh 'docker container run -d --rm --name my-demo-springboot -p 8081:8080 --network jenkins hoangledinh65/springboot-image:1.0'
            }
        }
    }
}