<?php

require_once "includes/auth.php";
require_once "includes/player.php";
require_once "includes/header.php";


$stmt = $pdo->prepare(" SELECT * FROM vehicles WHERE Owner = ? ");
$stmt->execute([ $player["Username"] ]);

$vehicles = $stmt->fetchAll();


?>


<div class="card">

<h2>
🚗 My Vehicles
</h2>


<?php


if(count($vehicles) == 0)
{

    echo "
    <div class='error'>
        You don't own any vehicles.
    </div>
    ";

}
else
{


foreach($vehicles as $vehicle)
{


echo "

<div class='vehicle-card'>


<div class='vehicle-info'>


<h3>
🚘 Model ID: ".$vehicle["model"]."
</h3>


<p>
<b>Position:</b><br>
X: ".$vehicle["posX"]."<br>
Y: ".$vehicle["posY"]."<br>
Z: ".$vehicle["posZ"]."
</p>


<p>
<b>Rotation:</b>
".$vehicle["rot"]."
</p>


<p>
<b>Colors:</b>
".$vehicle["color1"]." / ".$vehicle["color2"]."
</p>


<p>
<b>Paintjob:</b>
".$vehicle["paintjob"]."
</p>


<p>
<b>Fuel:</b>
".$vehicle["fuel"]."
%
</p>


</div>


</div>

";


}


}


?>


</div>


<?php

require_once "includes/footer.php";

?>