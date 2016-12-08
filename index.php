<?php

require_once 'vendor/autoload.php';

use Symfony\Component\Yaml\Yaml;
use HostsManager\homesteadYamlParser;



function lanIP($v){
    $file = "./.{$v}-ip";

    if (file_exists($file)) {
        $d = file_get_contents($file);
        return trim(str_replace('eth2: ', '', $d));
    }
    return false;
}

$boxes = [
    'php7 box' => 'php7',
    'php5.6 box' => 'php5.6'
];

$h = new homesteadYamlParser($boxes);

$hosts = $h->getHosts('LMO HOMESTEAD BOXES');

$sites = $h->getSites(); //getSites($boxes);

// $hosts = getHosts($boxes);

?>
<!DOCTYPE html>
<html>
<head>
    <title>Homestead Boxes</title>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
</head>
<body>
    
    <div class="container">
        
        <div class="row">
            <div class="col-md-5">

                <h1>Local Sites</h1>

                <p>Notes:</p>
                <dl>
                    <dt>h7 up</dt><dd>boot up machine and attach folder mounts</dd>
                    <dt>h7 provision </dt><dd>This will add new sites and process any intial scripts</dd>
                    <dt>h7 reboot</dt><dd>will reset/reboot the machine and provision (reload -- provision)</dd>
                    <dt>h7 edit</dt><dd>open homestead file in sublime for editing</dd>
                    <dt>h7 hosts</dt><dd>automatically update host file (requires password)</dd>
                    <dt></dt><dd>*May be <b>h5 xxx</b> depending on the box</dd>
                    <br>
                    <dt>h7_mysql</dt><dd>shortcut for mysql command with user/pass</dd>
                    <dt>h7_mysqldump</dt><dd>shortcut for mysqldump command with user/pass</dd>
                    <br>
                    <dt>h_update</dt><dd>update this tool</dd>
                </dl>
                
            </div>
            <div class="col-md-7">
                <h2>Host File</h2>

                <p>Please remember update your hosts file <b>h7 hosts</b> if new sites have been added using the printout below.</p>

                <pre><code><?=$hosts?></code></pre>
            </div>
        </div>

        
        <h2>Site Links</h2>
        
        <?php foreach ($boxes as $box => $f): ?>
            <table class="table table-striped">
            <thead>
                <tr><th colspan="3"><?=$box?></th></tr>
            </thead>
            <?php foreach ($sites[$box] as $name => $site): ?>
                <tr>
                    <td><?=$name?></td>
                    <td><a target="_blank" href="<?=$site['base']?>"><?=$site['base']?></a></td>
                    <td><?if($site['xip.io']):?><a target="_blank" href="<?=$site['xip.io']?>"><?=$site['xip.io']?></a><?endif;?></td>
                </tr>
            <?php endforeach; ?>
            </table>
        <?php endforeach; ?>
    


    </div>

</body>
</html>