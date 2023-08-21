#!/usr/bin/env nextflow
nextflow.enable.dsl=1
// If the user uses the --help flag, print the help text below
params.help = false

// Function which prints help message text
def helpMessage() {
    log.info"""
    Run the mappping pipeline for a given ref, short and long read dataset

    Required Arguments:
      --project       name        A project name
      --seedfile      file        A file contains genome_name,genome
      --outdir        path        Output s3 path

    Options:
      -profile        docker      run locally


    """.stripIndent()
}

// Show help message if the user specifies the --help flag at runtime
if (params.help){
    // Invoke the function above which prints the help message
    helpMessage()
    // Exit out and do not run anything else
    exit 0
}

if (params.outdir  == "null") {
	exit 1, "Missing the output path"
}
if (params.project == "null") {
	exit 1, "Missing the project name"
}
Channel
  .fromPath(params.seedfile)
  .ifEmpty { exit 1, "Cannot find the input seedfile" }

/*
 * Defines the pipeline inputs parameters (giving a default value for each for them)
 * Each of the following parameters can be specified as command line options
 */


Channel
 .fromPath(params.seedfile)
 .ifEmpty { exit 1, "Cannot find any seed file matching: ${params.seedfile}." }
 .splitCsv(header: ['genome', 'file'], sep: ',', skip: 1)
 .map{ row -> tuple(row.genome, row.file)}
 .set { seedfile_ch }


 process cctyper {
     tag "$genome"

     container params.container
     cpus { 16 * task.attempt }
     memory { 32.GB * task.attempt }

     errorStrategy { task.exitStatus in 137..140 ? 'retry' : 'terminate' }
     maxRetries 2

     //publishDir "${params.outdir}/${params.project}/${genome}", mode:'copy'
     //bash cctyper_wrapper.sh "$genome" "$file" "${params.project}" "${params.outdir}"

     input:
     tuple val(genome), val(file) from seedfile_ch

     output:

     script:
     """
     cctyper -h
     """
 }
