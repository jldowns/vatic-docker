<?php
    switch($_POST['action'])
    {
        case 'doLabels':
		ini_set('display_errors',1);
		ini_set('display_startup_errors',1);
		error_reporting(-1);
		$result = exec('cd ../..; turkic dump currentvideo --labelme mylabels -o /root/vatic/data/output.xml 2>&1');
		echo $result;
                exit();
      
    }
?>
