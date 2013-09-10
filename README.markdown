# whisper-merge-helper.sh

## Usage

    whisper-merge-helper.sh -- program help with merging StatsD whisper stores

    where:
      -?  show this help text
      -s  source_directory (example: /mnt/storage/api)
      -t  target_directory (example: /mnt/storage/api/v1)
      -n  StatsD namespace to cleanup
      -p  StatsD TCP interface (default: 8126)
      -h  StatsD TCP hostname (default: localhost)
      -c  Command to run (default: whisper-merge.py)
      -f  Force run. Do not exit on error
      -d  Dry run, and output debug information"

## Examples

    ./whisper-merge-helper.sh -s example/source -t example/target -n .foo
         echo $? #=> 0

    ./whisper-merge-helper.sh -s example/source -t example/target -n .foo -d

        Dry run: whisper-merge.py example/source/count.wsp example/target/count.wsp
        Dry run: whisper-merge.py example/source/rate.wsp example/target/rate.wsp
        Dry run: echo 'delcounters .foo' | nc localhost 8126
        Dry run: rm -r example/source

    ./whisper-merge-helper.sh -s example/source -t example/target -n .foo -d -c /opt/whisper.py

        Dry run: /opt/whisper.py example/source/count.wsp example/target/count.wsp
        Dry run: /opt/whisper.py example/source/rate.wsp example/target/rate.wsp
        Dry run: echo 'delcounters .foo' | nc localhost 8126
        Dry run: rm -r example/source