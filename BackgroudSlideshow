```shell
    #!/bin/sh
     
    if [ $# -gt 1 ]
    then
        echo
        echo "USAGE : $0 HH:MM:SS"
        echo "IF YOU DON'T DECLARE TIME, IT WILL BE AN HOUR"
        echo
        exit
    fi
     
    if [ $# -eq 1 ]
    then
        if [ `echo $1 | tr -d [1,2,3,4,5,6,7,8,9,0]` != :: ]
        then
            echo
            echo "$1 NOT LEGAL TIME :  HH:MM:SS"
            echo
            exit
        fi
        TempsAttente=$1
    else
        TempsAttente=01:00:00
    fi
     
    if [ $TempsAttente = :: ]
    then
        TempsAttente=00:30:00
    fi
     
    if [ ! -d $HOME/.ImagesDeFond ]
    then
        mkdir $HOME/.ImagesDeFond
        echo
        echo "PUT SOME PICTURES IN $HOME/.ImagesDeFond"
        echo
        exit
    else
        rmdir $HOME/.ImagesDeFond 2> $HOME/test.tmp
        if [ `cat $HOME/test.tmp | wc -c` -eq 0 ]
        then
            rm $HOME/test.tmp
            mkdir $HOME/.ImagesDeFond
            echo
            echo "PUT SOME PICTURES IN $HOME/.ImagesDeFond"
            echo
            exit
        fi
    fi
     
    S=`echo $TempsAttente | cut -d: -f3`
    M=`echo $TempsAttente | cut -d: -f2`
    H=`echo $TempsAttente | cut -d: -f1`
    M=`expr $M \* 60`
    H=`expr $H \* 3600`
    TempsAttente=`expr $S + $M + $H`
     
    if [ -f $HOME/.ImagesDeFond/ListPictures.txt ]
    then
        t=`ls $HOME/.ImagesDeFond | wc -l`
        t=`expr $t - 1`
        if [ $t -ne `cat $HOME/.ImagesDeFond/ListPictures.txt | wc -l` ]
        then
            rm -f $HOME/.ImagesDeFond/ListPictures.txt
        fi
    fi
     
    if [ ! -f $HOME/.ImagesDeFond/ListPictures.txt ]
    then
        ls $HOME/.ImagesDeFond | sed 's:\(.*\):'$HOME'/.ImagesDeFond/\1:' > $HOME/.ImagesDeFond/ListPictures.tmp
        cat $HOME/.ImagesDeFond/ListPictures.tmp | grep -v "ListPictures.tmp" > $HOME/.ImagesDeFond/ListPictures.txt
        rm $HOME/.ImagesDeFond/ListPictures.tmp
    fi
     
    n=`cat $HOME/.ImagesDeFond/ListPictures.txt | wc -l`
    n=`expr $n - 1`
    i=0
    taille=`du -b $HOME/.ImagesDeFond | tr "\t" ! | cut -f1 -d"!"`
     
     
    while [ $i -eq 0 ]
    do
        fondec=`head -n1 $HOME/.ImagesDeFond/ListPictures.txt`
        tail -n $n $HOME/.ImagesDeFond/ListPictures.txt > $HOME/.ImagesDeFond/toto.tmp
        echo $fondec >> $HOME/.ImagesDeFond/toto.tmp
        mv $HOME/.ImagesDeFond/toto.tmp $HOME/.ImagesDeFond/ListPictures.txt
        if [ $taille -ne `du -b $HOME/.ImagesDeFond | tr "\t" ! | cut -f1 -d"!"` ]
        then
            i=1
            rm -f $HOME/.ImagesDeFond/ListPictures.txt
        fi
        gsettings set org.gnome.desktop.background picture-uri "file://$fondec"
        sleep $TempsAttente
    done
     
    DiapoFondec.sh $1
```
