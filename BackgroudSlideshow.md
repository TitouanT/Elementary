```shell
    #!/bin/sh
     
    if [ $# -gt 1 ] # if there is too many argument
    then
        echo
        echo "USAGE : $0 HH:MM:SS"
        echo "IF YOU DON'T DECLARE TIME, IT WILL BE AN HOUR"
        echo
        exit # end of the script
    fi
     
    if [ $# -eq 1 ] # if there is the good number of argument 
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
     
    if [ $WaitTime = :: ] # if your argument is "::" 
    then
        WaitTime=00:30:00 # little shortcut if you want 30 minutes
    fi
     
    if [ ! -d $HOME/.BackgroudImage ] # if the folder ".BackgroundImage" doesn't exist...
    then
        mkdir $HOME/.BackgroudImage # ...then we create it...
        echo
        echo "PUT SOME PICTURES IN $HOME/.BackgroudImage" # ...and we ask the user to place some image in it.
        echo
        exit
    else
        rmdir $HOME/.BackgroudImage 2> $HOME/test.tmp   # if this line remove the folder ".BackgroudImage"
                                                        # that mean that he was empty.
        if [ `cat $HOME/test.tmp | wc -c` -eq 0 ]   # if that test is true that mean that "test.tmp" doesn't exist
        then                                        # so the folder ".BackgroudImage" have been removed
            mkdir $HOME/.BackgroudImage
            echo
            echo "PUT SOME PICTURES IN $HOME/.BackgroudImage"
            echo
            exit
        else
            rm $HOME/test.tmp
        fi
    fi
     
    S=`echo $WaitTime | cut -d: -f3` # S for seconds
    M=`echo $WaitTime | cut -d: -f2` # M for minutes
    H=`echo $WaitTime | cut -d: -f1` # H for hours
    M=`expr $M \* 60`                   # we convert minutes in seconds
    H=`expr $H \* 3600`                 # and hours in seconds
    WaitTime=`expr $S + $M + $H`        # then we have the time to wait in seconds
     
    if [ -f $HOME/.BackgroudImage/ListPictures.txt ] #here i stop
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
