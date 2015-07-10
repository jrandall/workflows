#!/usr/bin/env cwl-runner

class: CommandLineTool

description: "Invoke 'samtools sort' (samtools 1.19)"

requirements:
  - import: node-engine.cwl

inputs:
  - id: "#compression_level"
    type: ["null", int]
    description: |
      Set the desired compression level for the final output file, ranging from
      0 (uncompressed) or 1 (fastest but minimal compression) to 9 (best
      compression but slowest to write), similarly to gzip(1)'s compression
      level setting.

      If -l is not used, the default compression level will apply.

  - id: "#memory"
    type: ["null", int]
    description: |
      Approximately the maximum required memory per thread, specified  in
      bytes.

  - id: "#sort_by_name"
    type: ["null", boolean]
    description: "Sort by read names (i.e., the QNAME field) rather than by chromosomal coordinates."

  - id: "#output_name"
    type: string
    description: "Desired output filename."

  - id: "#input"
    type: File
    description:
      Input bam file.
    streamable: true

outputs:
  - id: "#output_file"
    type: File
    streamable: true
    outputBinding:
      glob:
        engine: "cwl:JsonPointer"
        script: "job/output_name"

baseCommand: ["bash", "-c"]

arguments:
  - valueFrom:
      engine: "node-engine.cwl"
      script: |
        {
          var opts = ["cat", $job['input'], "|", "samtools", "sort", "-f"];
          if($job['compression_level']) {
            opts = opts.concat(["-l", $job['compression_level']]);
          }
          if($job['memory']) {
            opts = opts.concat(["-m", $job['memory']]);
          }
          if($job['sort_by_name']) {
            opts = opts.concat(["-n"]);
          }
          opts = opts.concat(["-", $job['output_name']]);
          return opts;
        }
    itemSeparator: " "
