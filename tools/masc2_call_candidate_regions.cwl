label: MACS2 Call Candidate Regions
inputs:
- id: narrow_peak
  type: File
- id: bam
  type: File
  sbg:fileTypes: BAM
  secondaryFiles:
  - pattern: .bai
    required: true
- id: chr_sizes
  type: File
  required: true
- id: regions_blocklist
  type: File
  required: true
  sbg:fileTypes: BED
- id: regions_includelist
  type: File
  required: true
  sbg:fileTypes: BED
baseCommand:
- bash
- call_candidate_regions.sh
requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
- class: InitialWorkDirRequirement
  listing:
  - entryname: call_candidate_regions.sh
    writable: false
    entry: '#conda env create -f abcenv.yml


      python3 /usr/src/app/src/makeCandidateRegions.py \

      --narrowPeak $(inputs.narrow_peak.path) \

      --bam $(inputs.bam.path) \

      --outDir ./ \

      --chrom_sizes $(inputs.chr_sizes.path) \

      --regions_blocklist $(inputs.regions_blocklist.path) \

      --regions_includelist $(inputs.regions_includelist.path) \

      --peakExtendFromSummit 250 \

      --nStrongestPeaks 3000 '
- class: InlineJavascriptRequirement
outputs:
- id: macs2_outputs
  type: File[]?
  outputBinding:
    glob: '*.macs2*'
cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  sbg: https://sevenbridges.com
hints:
- class: sbg:SaveLogs
  value: '*.sh'
