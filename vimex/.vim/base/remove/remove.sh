PARA_CNT=$#
TRASH_DIR="$HOME/.trash"

for i in $*; do
    STAMP=`date "+%Y%m%d%H%M%S"`
    fileName=`basename $i`
    mv $i $TRASH_DIR/$fileName.$STAMP
done
