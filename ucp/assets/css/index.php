<?php

echo '
<!DOCTYPE html>
<html>
<head>

<title>Oops!</title>

<style>

body
{
    background:#1e1e1e;
    color:white;
    font-family:Arial, Helvetica, sans-serif;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
    text-align:center;
}

.box
{
    background:#2b2b2b;
    padding:40px;
    border-radius:10px;
    border-left:5px solid #e74c3c;
}

h1
{
    color:#e74c3c;
}

</style>

</head>

<body>

<div class="box">

<h1>😅 Oops!</h1>

<p>
Where are you trying to go?
</p>

<p>
This page does not exist.
</p>

<a href="../dashboard.php">
<button>
Return to UCP
</button>
</a>

</div>

</body>
</html>
';

?>