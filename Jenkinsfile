#!/usr/bin/env groovy
// please look at: https://jenkins.io/doc/book/pipeline/syntax/
BranchName = env.BRANCH_NAME

def MailRecipient = 'dl_iet_amaron@philips.com'
def LogLevel = env.Verbose

pipeline {

    agent {
        node {
            label 'xcode && 12.0'
        }
    }

    parameters {
        booleanParam(name: 'RemoveWorkspace', defaultValue: false, description: 'Remove Workspace')
        booleanParam(name: 'Verbose', defaultValue: false, description: 'Verbose logging')
        booleanParam(name: 'GenerateAPIDocs', defaultValue: false, description: 'Generate API Documentation')
        booleanParam(name: 'RunAllTests', defaultValue: false, description: 'Build and run all unit tests')
    }


    environment {
        BUILD_FROM_ARTIFACTORY = 'false'
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '24'))
    }

    stages {

        stage('Initialize') {
            steps {
                script {
                    if (!params.RemoveWorkspace) {
                        echo "Removing Workspace per user choice"
                        deleteDir()
                        checkout scm
                    } else {
                        echo "Skipping Workspace removal and Removing results and ipa files from path"
                        sh "pwd"
                        sh "rm -rf Source/results/*"
                        sh "rm -rf Source/build/*.ipa"
                    }
                    sh "rm -rf ~/Library/Developer/Xcode/DerivedData"
                    sh "rm -rf Source/DerivedData"
                }
                InitialiseBuild()
                script {
                    sh '''#!/bin/bash -l
                        ./ci-build-support/update_version.sh
                    '''
                }
                updatePods("Source/Library",LogLevel)
            }
        }

        stage('Zip Components') {
            when {
                anyOf { branch 'develop'; branch 'release/platform_*' }
            }
            steps {
                script {
                    def zipScript =
                    '''#!/bin/bash -xl
                        PODSPEC_PATH="ci-build-support/Versions.rb"
                        VERSION_REGEX="VersionCSWPlatform[^'|\\"]*['|\\"]([^'|\\"]*)['|\\"]"
                        COMPONENT_VERSION=`cat $PODSPEC_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\\1/"`
                        COMMIT_HASH=`git rev-parse HEAD`

                        export ZIPFOLDER="Zips"
                        cd Source
                        mkdir -p "${ZIPFOLDER}"
                        mkdir -p "${ZIPFOLDER}/Source"
                        echo "Zipping started"

                        for i in */; do
                            if [ "$i" == "Library/" ] ; then
                                export ZIPPATH="${ZIPFOLDER}/${i%/}_${COMMIT_HASH}.zip"
                                echo "Creating zip for Component ${i} in path ${ZIPPATH}"
                                cp -R "${i}" "${ZIPFOLDER}/Source/${i}"
                                cd ${ZIPFOLDER}
                                zip -r "../${ZIPPATH}" "Source/${i}"
                                rm -rf Source/*
                                cd -
                            fi
                        done
                        echo "Zipping ended"
                    '''
                    echo zipScript
                    sh zipScript
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    def shouldForceUnitTests = false
                    releaseBranchPattern = "release/platform_*"
                    developBranchPattern = "develop"

                    if (BranchName =~ /${releaseBranchPattern}/ || BranchName == developBranchPattern) {
                        shouldForceUnitTests = true
                    }
                    runTestsWith(true, "ConsentWidgetsDev", "CSW Test Report")
                }
            }
        }

        stage('Publish Zips') {
            when {
                anyOf { branch 'develop'; branch 'release/platform_*' }
            }
            steps {
                script {
                    boolean ReleaseBranch = (BranchName ==~ /release\/platform_.*/)
                    def publishScript =
                    '''#!/bin/bash -l
                        PODSPEC_PATH="ci-build-support/Versions.rb"
                        VERSION_REGEX="VersionCSWPlatform[^'|\\"]*['|\\"]([^'|\\"]*)['|\\"]"
                        COMPONENT_VERSION=`cat $PODSPEC_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\\1/"`

                        ARTIFACTORY_REPO="iet-mobile-ios-release-local"

                        export ZIPFOLDER="Zips"
                        export ARTIFACTORY_URL="https://artifactory-ehv.ta.philips.com/artifactory/${ARTIFACTORY_REPO}/com/philips/platform/Zip_Sources"
                        cd Source
                        echo "Upload started"
                        cd ${ZIPFOLDER}
                        rm -rf Source
                        pwd
                        for i in *; do
                            export ARTIFACTORYUPLOADURL="${ARTIFACTORY_URL}/${COMPONENT_VERSION}/${i}"
                            echo "Uploading Zip for $i at path ${ARTIFACTORYUPLOADURL}"
                            curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "${ARTIFACTORYUPLOADURL}" -T $i
                        done
                        echo "Upload ended"
                        cd -
                        echo "Removing Zips Folder"
                        rm -rf ${ZIPFOLDER}
                    '''
                    echo publishScript
                    sh publishScript
                }
            }
        }

        stage('Publish Podspecs') {
            when {
                anyOf { branch 'develop'; branch 'release/platform_*' }
            }
            steps {
                script {
                    publish("./ConsentWidgets.podspec", "./Source/Library/Podfile.lock")
                }
            }
        }

        stage('Publish API Docs') {
            when {
                expression { return params.GenerateAPIDocs }
            }
            steps {
                publishAPIDocs()
            }
        }

    }
    post {
        always{
          notifyBuild(currentBuild.result)
        }
    }
}


def notifyBuild(String buildStatus = 'STARTED') {
    // build status of null means successful


    buildStatus =  buildStatus ?: 'success' || 'failure' || 'fixed' || 'unstable'
   // Default values
   def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
   def details = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]': Check console output at ${env.BUILD_URL}"
    emailext (
        subject: subject,
        body: details,
        to: "dl_iet_amaron@philips.com, dl_iet_exide@philips.com, rallapalli.prasad@philips.com"
    )
}

def InitialiseBuild() {
    committerName = sh (script: "git show -s --format='%an' HEAD", returnStdout: true).trim()
    currentBuild.description = "Submitter: " + committerName + ";Node: ${env.NODE_NAME}"
    echo currentBuild.description

    echo currentBuild.displayName
}


def runTestsWith(Boolean isWorkspace, String testSchemeName, String frameworkName = " ", Boolean hasCucumberOutput = false) {

    // This is only used for code coverage and test result output/attachments
    def resultBundlePath = "results/" + testSchemeName
    def binaryPath = frameworkName  + "/"+ frameworkName + ".framework/" + frameworkName


    def testScript = """
        #!/bin/bash -l
        export PATH=/.rbenv/shims:/usr/local/bin/xcpretty/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

        killall Simulator || true
        xcrun simctl erase all || true

        cd ${"Source/Library"}

        #Set XCPretty output format
        export LC_CTYPE=en_US.UTF-8

        xcodebuild clean test \
                -workspace ${"ConsentWidgets.xcworkspace"} \
                -scheme ${testSchemeName} CLANG_WARN_DOCUMENTATION_COMMENTS='NO'\
                -destination \'platform=iOS Simulator,name=iPhone 8,OS=latest\' \
                -UseModernBuildSystem='NO'\
                -resultBundlePath ${resultBundlePath} \
                | xcpretty --report junit --report html
    """

    echo testScript
    sh testScript

    junit allowEmptyResults: false, testResults: "Source/Library/build/reports/junit.xml"
    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: "Source/Library/build/reports", reportFiles: 'tests.html', reportName: frameworkName+' Test Report'])

    if (hasCucumberOutput) {
        def attachmentsFolder = 'Source/Library'+resultBundlePath+'/Attachments'
        step([$class: 'CucumberReportPublisher', jsonReportDirectory: attachmentsFolder, fileIncludePattern: '*.json'])
        archiveArtifacts artifacts: attachmentsFolder+'/*.json', fingerprint: true, onlyIfSuccessful: true
    }
}


def publish(String podspecPath, String podfileLockPath) {
    sh """#!/bin/bash -l
        chmod 755 ./ci-build-support/substitute_version.groovy
        ci-build-support/substitute_version.groovy ${podspecPath}
        ci-build-support/podspec_push.sh ${podspecPath} $BRANCH_NAME
    """
}


def generateBOMFileforConfluence(String podfileLockPath, String outputFile) {
    sh """#!/bin/bash -l
        ci-build-support/CreateBOMFromPodfile.groovy -i ${podfileLockPath} -o ${outputFile}
    """
}


String getArtifactoryBasePath() {
    boolean ReleaseBranch = (BranchName ==~ /release\/platform_.*/)
    boolean DevelopBranch = (BranchName ==~ /develop/)

    def basePathShellScript = '''#!/bin/bash -l
        ARTIFACTORY_URL="https://artifactory-ehv.ta.philips.com/artifactory"

        ARTIFACTORY_REPO="iet-mobile-ios-release-local"

        echo "$ARTIFACTORY_URL/$ARTIFACTORY_REPO/com/philips/platform"
    '''

    return sh(script: basePathShellScript, returnStdout: true).trim()
}


String getCDP2PlatformVersionNumber() {
    def versionNumberShellScript = '''#!/bin/bash -l
        VERSIONS_FILE_PATH="ci-build-support/Versions.rb"

        if [ ! -f "${VERSIONS_FILE_PATH}" ]
        then
            echo ""
            exit 1
        fi

        VERSION_REGEX="VersionCSWPlatform[^'|\\"]*['|\\"]([^'|\\"]*)['|\\"]"
        cat $VERSIONS_FILE_PATH | egrep -o $VERSION_REGEX | sed -E "s/$VERSION_REGEX/\\1/"
    '''

    return sh(script: versionNumberShellScript, returnStdout: true).trim()
}


def publishAPIDocs() {
    String artifactoryBasePath = getArtifactoryBasePath()
    String versionNumber = getCDP2PlatformVersionNumber()

    echo "Using Artifactory BasePath ["+artifactoryBasePath+"]"
    echo "using versionNumber ["+versionNumber+"]"

    def shellcommand = '''#!/bin/bash -l
        set -e

        if [ -z "'''+artifactoryBasePath+'''" ]
        then
            echo "Not published as build is not on a develop or release branch" . $BranchName
            exit 0
        fi

        API_DOC_ZIP="API_DOCS_'''+versionNumber+'''.zip"
        zip -r $API_DOC_ZIP API_DOCS
        curl -L -u 320049003:AP4ZB7JSmiC4pZmeKfKTGLsFvV9 -X PUT "'''+artifactoryBasePath+'''"/API_DOCS/ -T $API_DOC_ZIP
    '''
    echo shellcommand
    sh shellcommand
}


def updatePods(String podfilePath, String logLevel) {
    sh '''#!/bin/bash -l
         rm -rf ./Source/Library/Podfile.lock
    '''
    echo "Running pod install for ${podfilePath}"
    if (logLevel == "true") {
        sh '''#!/bin/bash -l
            cd ./Source/Library && pod cache clean --all && pod repo update --verbose && pod install --verbose
        '''
    } else {
        sh '''#!/bin/bash -l
            cd ./Source/Library && pod cache clean --all && pod repo update && pod install
        '''
    }
}
