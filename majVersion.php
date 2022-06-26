<?php 

const VERSION_FILE=__DIR__.'/common/singletons/globalVersion.gd';
const APPDATA_FILE=__DIR__.'/export/linux/flatpack/org.dupot.littleadventure.appdata.xml';
const EXPORT_FILE=__DIR__.'/export_presets.cfg';


const RET="\n";

function getVersion(){
    $versionLineList=file(VERSION_FILE);
    foreach($versionLineList as $lineLoop){

        if (preg_match('/version/',$lineLoop)){

            if(preg_match('/([0-9]+.[0-9]+)/',$lineLoop,$match))
            $version=$match[1];

            return $version;
        }

    }

    die('Error version not found');

}

function majExportFile($version,$versionCode){

    $exportFile=EXPORT_FILE;
    $lineList=file($exportFile);
    foreach($lineList as $i => $lineLoop){
        
        if(preg_match('/version/',$lineLoop) and preg_match('/code/',$lineLoop)){

            $lineList[$i]='version/code='.$versionCode.RET;

        }else if(preg_match('/version/',$lineLoop) and preg_match('/name/',$lineLoop)){

            $lineList[$i]='version/name="'.$version.'"'.RET;

        }


    }

    $exportFileContent=implode("",$lineList);

    system('cp '.EXPORT_FILE.' '.EXPORT_FILE.'.backup'.date('Y-m-d_His'));

    file_put_contents(EXPORT_FILE,$exportFileContent);

}


$version=getVersion();
$versionList=explode('.',$version);
$versionCode=$versionList[1];

$appDataXml=simplexml_load_file(APPDATA_FILE);

$previousChildren=clone $appDataXml->releases->children();

//dd($children);

unset($appDataXml->releases);

$appDataXml->releases=new SimpleXMLElement('<releases />');

$releaseLine = $appDataXml->releases->addChild('release');
$releaseLine->addAttribute('date', date('Y-m-d'));
$releaseLine->addAttribute('version', $version);

foreach($previousChildren as $previousChildLoop){

    $dateLoop=(string)$previousChildLoop['date'];
    $version=(string)$previousChildLoop['version'];
    
    $releaseLineLoop = $appDataXml->releases->addChild('release');
    $releaseLineLoop->addAttribute('date', $dateLoop);
    $releaseLineLoop->addAttribute('version', $version);
}


$xml = formatXml($appDataXml->asXML());

//echo $xml;exit;

file_put_contents(APPDATA_FILE,$xml);

majExportFile($version,$versionCode);


function dd($obj){

    var_dump($obj);exit;

}

function formatXml($xml){

    $dom = new DOMDocument;
    $dom->preserveWhiteSpace = false;
    $dom->formatOutput = true;
    $dom->loadXML($xml); 

    return $dom->saveXML();
}