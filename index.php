<?php

require_once 'vendor/autoload.php';

use Symfony\Component\Yaml\Yaml;

function parseYaml($folder) {
    return Yaml::parse(file_get_contents("{$folder}/Homestead.yaml"));
}

function lanIP($v){
    $file = "./.{$v}-ip";

    if (file_exists($file)) {
        $d = file_get_contents($file);
        return trim(str_replace('eth2: ', '', $d));
    }
    return false;
}

function getBoxes($boxes) {
    foreach ($boxes as $key => $folder) {
        $data = parseYaml($folder);
        $data['folder'] = $folder;
        $boxes[$key] = $data;
    }
    return $boxes;
}

function getSites($boxes) {

    $sites = [];
    foreach ($boxes as $key => $box) {
        foreach ($box['sites'] as $site) {
            $v = $box['folder'];
            $sites[$key][$site['map']]['base'] = 'http://'.$site['map'];
            $sites[$key][$site['map']]['xip.io'] = false;
            if (lanIP($v)) {
                $sites[$key][$site['map']]['xip.io'] = 'http://'.$site['map'].'.'.lanIP($v).'.xip.io';
            }
        }
        // add mailcatcher
        $sites[$key]['mailcatcher']['base'] = "http://{$box['ip']}:1080";
        $sites[$key]['mailcatcher']['xip.io'] = "http://{$box['ip']}:1080";
        
    }
    return $sites;
}

function getHosts($boxes) {
    
    $hosts = [];
    $hosts[] = '# LMO HOMESTEAD BOXES';
    foreach ($boxes as $key => $box) {
        $sites = [];
        foreach ($box['sites'] as $site) {
            $sites[] = $site['map'];
        }
        $hosts[] = $box['ip'] . ' ' . implode(' ', $sites);
    }
    return implode("\n", $hosts);
}


$boxes = [
    'php7 box' => 'php7',
    'php5.6 box' => 'php5.6'
];

$boxes = getBoxes($boxes);

$sites = getSites($boxes);

$hosts = getHosts($boxes);

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
        <h1>Local Sites</h1>

        <p>some quick vagrant notes:</p>
        <dl>
            <dt>h7 provision </dt><dd>This will add new sites and process any intial scripts</dd>
            <dt>h7 up</dt><dd>boot up machine and attach folder mounts</dd>
        </dl>
        
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
        

        <h2>Host File</h2>

        <p>Please remember update your hosts file if new sites have been added using the printout below.</p>

        <pre><code><?=$hosts?></code></pre>
    </div>

</body>
</html>