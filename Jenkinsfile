pipeline {
    agent any

    stages {
        stage('Check Tools') {
            steps {
                sh 'git --version'
                sh 'java -version'
                sh 'mvn -version'
                sh 'aws --version'
            }
        }

        stage('Build Java Application') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Upload JAR to S3') {
            steps {
                sh '''
                    JAR_FILE=$(find target -maxdepth 1 -type f -name "*.jar" \
                      ! -name "*-sources.jar" \
                      ! -name "*-javadoc.jar" | head -n 1)

                    if [ -z "$JAR_FILE" ]; then
                        echo "No JAR file found in target directory"
                        exit 1
                    fi

                    VERSIONED_JAR="java-microservice-v${BUILD_NUMBER}.jar"

                    cp "$JAR_FILE" "$VERSIONED_JAR"

                    aws s3 cp "$VERSIONED_JAR" \
                      "s3://vaishnavi-java-jar-artifacts-2026/$VERSIONED_JAR"
                '''
            }
        }
    }
}