```shell
    #!/bin/sh
     
    if [ $# -gt 1 ]
    then
        echo
        echo "USAGE : $0 HH:MM:SS"
        echo "IF YOU DON'T DECLARE TIME, IT WILL BE AN HOUR"
        echo
        exit # end of the script
    fi
     
    if [ $# -eq 1 ]
    then
        if [ `echo $1 | tr -d [1,2,3,4,5,6,7,8,9,0]` != :: ]
        then
            echo
            echo "$1 NOT LEGAL TIME :  HH:MM:SS"
            echo
            exit # end of the script
        fi
        WaitTime=$1
    else
        WaitTime=01:00:00 # time by default if there is no argument
    fi
     
    if [ $WaitTime = :: ]
    then
        WaitTime=00:30:00 # little shortcut if you want 30 minutes
    fi
     
    if [ ! -d $HOME/.BackgroudImage ]
    then
        mkdir $HOME/.BackgroudImage
        echo
        echo "PUT SOME PICTURES IN $HOME/.BackgroudImage"
        echo
        exit
    else
        rmdir $HOME/.BackgroudImage 2> $HOME/test.tmp
        if [ `cat $HOME/test.tmp | wc -c` -eq 0 ]
        then
            rm $HOME/test.tmp
            mkdir $HOME/.BackgroudImage
            echo
            echo "PUT SOME PICTURES IN $HOME/.BackgroudImage"
            echo
            exit
        fi
    fi
     
    S=`echo $WaitTime | cut -d: -f3`
    M=`echo $WaitTime | cut -d: -f2`
    H=`echo $WaitTime | cut -d: -f1`
    M=`expr $M \* 60`
    H=`expr $H \* 3600`
    WaitTime=`expr $S + $M + $H`
     
    if [ -f $HOME/.BackgroudImage/ListPictures.txt ]
    then
        t=`ls $HOME/.BackgroudImage | wc -l`
        t=`expr $t - 1`
        if [ $t -ne `cat $HOME/.BackgroudImage/ListPictures.txt | wc -l` ]
        then
            rm -f $HOME/.BackgroudImage/ListPictures.txt
        fi
    fi
     
    if [ ! -f $HOME/.BackgroudImage/ListPictures.txt ]
    then
        ls $HOME/.BackgroudImage | sed 's:\(.*\):'$HOME'/.BackgroudImage/\1:' > $HOME/.BackgroudImage/ListPictures.tmp
        cat $HOME/.BackgroudImage/ListPictures.tmp | grep -v "ListPictures.tmp" > $HOME/.BackgroudImage/ListPictures.txt
        rm $HOME/.BackgroudImage/ListPictures.tmp
    fi
     
    n=`cat $HOME/.BackgroudImage/ListPictures.txt | wc -l`
    n=`expr $n - 1`
    i=0
    taille=`du -b $HOME/.BackgroudImage | tr "\t" ! | cut -f1 -d"!"`
     
     
    while [ $i -eq 0 ]
    do
        fondec=`head -n1 $HOME/.BackgroudImage/ListPictures.txt`
        tail -n $n $HOME/.BackgroudImage/ListPictures.txt > $HOME/.BackgroudImage/toto.tmp
        echo $fondec >> $HOME/.BackgroudImage/toto.tmp
        mv $HOME/.BackgroudImage/toto.tmp $HOME/.BackgroudImage/ListPictures.txt
        if [ $taille -ne `du -b $HOME/.BackgroudImage | tr "\t" ! | cut -f1 -d"!"` ]
        then
            i=1
            rm -f $HOME/.BackgroudImage/ListPictures.txt
        fi
        gsettings set org.gnome.desktop.background picture-uri "file://$fondec"
        sleep $WaitTime
    done
     
    BackgroudSlideshow.sh $1
```
