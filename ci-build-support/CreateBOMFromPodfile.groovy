#!/usr/bin/env groovy

start(args)

def start(args) {
    def cli = new CliBuilder( usage: 'groovy CreateBOMFromPodfile.groovy -i <Podfile.lock> -o <output file>');

    cli.with {
        h longOpt: 'help', 'Show usage information'
        i longOpt: 'inputFile', 'The relative location of the Podfile.lock', args:1
        o longOpt: 'outputFile', 'The location with output filename', args:1
    }

    def options = cli.parse(args)
    if (!options) {
        return
    }

    if (options.h) {
        cli.usage()
        return
    }

    if (!options.i) {
        println("Need a podfile.lock")
        cli.usage()
        return
    }

    if (!options.o) {
        println("Need a outputFile")
        cli.usage()
        return
    }

    CreateBOMFromPodfile(options.i, options.o)
}

def CreateBOMFromPodfile(String pathToPodspecFile, String pathToOutputFile) {
    println("Podfile : ${pathToPodspecFile}")
    File podSpecFile = new File("${pathToPodspecFile}")
    println("outputFile : ${pathToOutputFile}")
    File outputFile = new File("${pathToOutputFile}")

    println("Check if Podfile exist")
    if(!podSpecFile.exists()){
        println("Podspec file does not exist")
        return
    }

    println("Delete outputFile if exist")
    if(outputFile.exists()){
        println("outputFile file does exist and will be deleted")
        outputFile.delete()
    }

    println("Generate outputFile")
    def podspecLines = podSpecFile.readLines()
    for (int lineNr = 0; lineNr < podspecLines.size(); lineNr++) {
        def result = ExtractComponentNameAndVersionFromPodfileLine(podspecLines[lineNr])

        if (result.ComponentName != '') {
            println("pod '$result.ComponentName', '$result.VersionString'")
            outputFile << ("pod '$result.ComponentName', '$result.VersionString'\r\n")
        }
    }
}

static def ExtractComponentNameAndVersionFromPodfileLine(String line) {
    def groupMatch = (line =~ /^\s{2}-\s(\S*)\s\((\d+.\d+.\d+.*)\)/ )
    String name = ""
    String version = ""

    if (groupMatch.size() > 0 ){
        name = groupMatch[0][1]
        version = groupMatch[0][2]
    }

    return [
        ComponentName:name,
        VersionString:version
    ]
}
