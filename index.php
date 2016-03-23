<?php

require_once 'vendor/autoload.php';

use Symfony\Component\Yaml\Yaml;

function parseYaml($folder) {
    return Yaml::parse(file_get_contents("{$folder}/Homestead.yaml"));
}

function lanIP(){
    $file = '../.ip';
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
            $sites[$key][$site['map']]['base'] = 'http://'.$site['map'];
            $sites[$key][$site['map']]['xip.io'] = false;
            if (lanIP()) {
                //$sites[$key][$site['map']]['xip.io'] = 'http://'.$site['map'].'.'.lanIP().'.xip.io';
            }
            
        }
        
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
</head>
<body>

    <h1>Local Sites</h1>

    <h2>Site Links</h2>
    
    <ul>
        <?php foreach ($boxes as $box => $f): ?>
            <li style="font-weight: bold"><?=$box?></li>
            <ul>
            <?php foreach ($sites[$box] as $name => $site): ?>
                <li><a href="<?=$site['base']?>"><?=$name?></a>
                    <?if($site['xip.io']):?>
                    <a href="<?=$site['xip.io']?>"><?=$site['xip.io']?></a>
                    <?endif;?>
                </li>
            <?php endforeach; ?>
            </ul>
        <?php endforeach; ?>
    </ul>

    <h2>Host File</h2>

    <pre><code><?=$hosts?></code></pre>

</body>
</html>