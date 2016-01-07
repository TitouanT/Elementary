
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
     
    if [ ! -d $HOME/.BackgroudImage ]                       # if the folder ".BackgroundImage" doesn't exist...
    then
        mkdir $HOME/.BackgroudImage                         # ...then we create it...
        echo
        echo "PUT SOME PICTURES IN $HOME/.BackgroudImage"   # ...and we ask the user to place some image in it.
        echo
        exit                                                # end of the script
    else
        rmdir $HOME/.BackgroudImage 2> $HOME/test.tmp   # if this line remove the folder ".BackgroudImage"
                                                        # that mean that he was empty.
        if [ `cat $HOME/test.tmp | wc -c` -eq 0 ]   # if that test is true that mean that "test.tmp" contain nothing ( no error)
        then                                        # so the folder ".BackgroudImage" have been removed
            mkdir $HOME/.BackgroudImage                         # then we recreate it...
            echo
            echo "PUT SOME PICTURES IN $HOME/.BackgroudImage"   # ...and we ask the user to place some image in it.
            echo
            exit                                                # end of the script
        fi
        
        rm $HOME/test.tmp
    fi
     
    S=`echo $WaitTime | cut -d: -f3` # S for seconds
    M=`echo $WaitTime | cut -d: -f2` # M for minutes
    H=`echo $WaitTime | cut -d: -f1` # H for hours
    M=`expr $M \* 60`                   # we convert minutes in seconds
    H=`expr $H \* 3600`                 # and hours in seconds
    WaitTime=`expr $S + $M + $H`        # then we have the time to wait in seconds
     
    if [ -f $HOME/.BackgroudImage/ListPictures.txt ] #this test is true if ListPictures.txt exist
    then
        t=`ls $HOME/.BackgroudImage | wc -l`    # number of file in the folder
        t=`expr $t - 1`                         # number of image in the folder
        if [ $t -ne `cat $HOME/.BackgroudImage/ListPictures.txt | wc -l` ]
        then
            rm -f $HOME/.BackgroudImage/ListPictures.txt  # to be sure that the file is not old
        fi
    fi
     
    if [ ! -f $HOME/.BackgroudImage/ListPictures.txt ]  # to know if ListPictures.txt doesn't exist
    then                                                # or if it have been removed because it was old
        ls $HOME/.BackgroudImage | sed 's:\(.*\):'$HOME'/.BackgroudImage/\1:' > $HOME/.BackgroudImage/ListPictures.tmp
        # this sed line write the full address of each image (one per line)
        cat $HOME/.BackgroudImage/ListPictures.tmp | grep -v "ListPictures.tmp" > $HOME/.BackgroudImage/ListPictures.txt
        # I use grep -v ton invert the sense of matching, in order to select only the image
        rm $HOME/.BackgroudImage/ListPictures.tmp
    fi
     
    n=`cat $HOME/.BackgroudImage/ListPictures.txt | wc -l`
    n=`expr $n - 1`
    i=0
    size=`du -b $HOME/.BackgroudImage | tr "\t" ! | cut -f1 -d"!"`    # "du" for Disk Usage and "-b" for Bytes
     
     
    while [ $i -eq 0 ] # if the user don't touch the folder ".BackgroudImage", this is a infinite loop
    do
        image=`head -n1 $HOME/.BackgroudImage/ListPictures.txt` # It stock the first image of the list in "image"
        tail -n $n $HOME/.BackgroudImage/ListPictures.txt > $HOME/.BackgroudImage/ListPictures.tmp 
        # It write the following of the file in a temporary file
        echo $image >> $HOME/.BackgroudImage/ListPictures.tmp 
        # It add the image stocked in "image" at the end of the temporary file
        mv $HOME/.BackgroudImage/ListPictures.tmp $HOME/.BackgroudImage/ListPictures.txt 
        # Then the temporary file become the new "ListPictures.txt"
        if [ $size -ne `du -b $HOME/.BackgroudImage | tr "\t" ! | cut -f1 -d"!"` ]
        then # that mean that the user have add or delete some pictures in ".BackgroudImage"
            i=1
            rm -f $HOME/.BackgroudImage/ListPictures.txt 
        fi
        gsettings set org.gnome.desktop.background picture-uri "file://$image"
        sleep $WaitTime
    done
     
    BackgroudSlideshow.sh $1 #at the end the script call himself to actualize "ListPictures.txt"

