<?php
function GetBackpackCapacity($score)
{
    if($score <= 5) return 8;
    if($score <= 10) return 16;
    if($score <= 15) return 32;
    if($score <= 20) return 64;
    if($score <= 25) return 128;
    return 256;
}