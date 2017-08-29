# Generate random things more than number
## Usage:
1.Number

    (random-num)            ;(default) integer between [0,100)
    (random-num 1.0)        ;decimal between [0,1)
    (random-num 50)         ;integer between [0,50)
    (random-num -50)        ;integer between [-50,0)
    (random-num 50 100)     ;integer between [50,100)
    (random-num 50.0 100)   ;decimal between [50,100)
    (random-num -50 100)    ;integer between [-50,100)
    (random-num -100 -50)   ;integer between [-100,-50)
    
    (random-num-range -50 -20 18 30 45 60)  ;;integer between [-50,-20) or [18,30) or [45,60)
    
2.String

    (random-string)         => "^\"nRo,.//e"
    (random-string :max-len 5 :random-len t :min-len 1)   => "3A" or "a]3AE" or "]"
    
    (random-alpha)          => "B" or "b"
    (random-alpha :max-len 10 :upper t)                   => "ODBALNMXHS"
    
    (random-digital)        => "9"
    (random-digital :max-len 6)                           => "142857"
    
    (random-name)           => "东方萌"
    
3.Array

    (random-array) ;defalut size:100 range:[0,100) integer
    (random-array :size 500 :range 100)
     
     
