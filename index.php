<?php

require_once 'vendor/autoload.php';

use Symfony\Component\Yaml\Yaml;

function parseYaml($folder) {
    return Yaml::parse(file_get_contents("{$folder}/Homestead.yaml"));
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
            $sites[] = 'http://'.$site['map'];
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
    'php7' => 'php7',
    'php56' => 'php5.6'
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
    
    <ul>
        <?php foreach ($sites as $site): ?>
           <li><a href="<?=$site?>"><?=$site?></a></li>
        <?php endforeach; ?>
    </ul>

    <h2>Host File</h2>

    <pre><code><?=$hosts?></code></pre>

</body>
</html>