#!/usr/bin/env cwl-runner

class: CommandLineTool

description: "Invoke 'samtools index' to create a 'BAI' index (samtools 1.19)"

requirements:
  - import: node-engine.cwl

inputs:
  - id: "#input"
    type: File
    description:
      Input bam file.
    streamable: true

outputs:
  - id: "#bam_with_bai"
    type: File
    outputBinding:
      glob: "indexed.bam"
      secondaryFiles:
        - ".bai"

baseCommand: ["bash", "-c"]

arguments:
  - valueFrom:
      engine: "node-engine.cwl"
      script: |
        {
          return ["rm -f ${TMPDIR}/indexed.fifo.bam ${TMPDIR}/indexed.fifo.bam.bai; mkfifo ${TMPDIR}/indexed.fifo.bam; mkfifo ${TMPDIR}/indexed.fifo.bam.bai; (cat", $job['input'], "| tee indexed.bam ${TMPDIR}/indexed.fifo.bam > /dev/null)& (cat ${TMPDIR}/indexed.fifo.bam.bai > indexed.bam.bai)& samtools index ${TMPDIR}/indexed.fifo.bam"];
        }
    itemSeparator: " "
