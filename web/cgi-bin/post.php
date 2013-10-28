<?php

/* Config */

define('MF_MYSQL_HOST', 'localhost');
define('MF_MYSQL_USER', 'www');
define('MF_MYSQL_PASS', '');
define('MF_MYSQL_NAME', 'reloved');

/* DB Adapter */

class MF_DB {
	private static $connection = null;
	
	public static function connect() {
		if(!self::$connection) {
			if(!(self::$connection = mysql_connect(MF_MYSQL_HOST, MF_MYSQL_USER, MF_MYSQL_PASS))) {
				throw new Exception(mysql_error());
			}
			
			if(!mysql_select_db(MF_MYSQL_NAME, self::$connection)) {
				throw new Exception(mysql_error());
			}
		}
	}
	
	public static function disconnect() {
		mysql_close(self::$connection);
		self::$connection = null;
	}
	
	public static function query($query) {
		MF_DB::connect();
		
		$count = func_num_args();
		$length = 0;
		
		if($count > 1) {
			$query_t = '';
			$offset_p = 0;
			
			for($index = 1; $index < $count; $index++) {
				$value = func_get_arg($index);
				$offset_n = strpos($query, '?', $offset_p);
				$query_t .= substr($query, $offset_p, $offset_n - $offset_p);
				$query_t .= (is_int($value)) ? $value : (($value === NULL) ? "NULL" : "'".mysql_real_escape_string($value)."'");
				$offset_p = $offset_n + 1;
			}
			
			$query = $query_t.substr($query, $offset_p);
		}
		
		$result = mysql_query($query, self::$connection);
		echo mysql_error();
		
		if(!isset($result)) {
			throw new Exception(mysql_error());
		}
		
		return $result;
	}
	
	public static function fetch($link) {
		return @mysql_fetch_array($link, MYSQL_ASSOC);
	}
}

class MF_Post {
	public $id = null;
	public $brandId = null;
	public $brandName = null;
	public $sizeId = null;
	public $sizeName = null;
	public $condition = null;
	public $materials = null;
	public $price = null;
	public $priceOriginal = null;
	public $currency = null;
	public $title = null;
	public $fit = null;
	public $notes = null;
	public $editorial = null;
	
	private $_media = null;
	
	public static function find($id) {
		$query = MF_DB::query(
			'SELECT DISTINCT posts.*, brands.name AS brand_name, sizes.name AS size_name FROM posts '.
				'LEFT JOIN brands ON brands.id = posts.brand_id '.
				'LEFT JOIN sizes ON sizes.id = posts.size_id '.
				'WHERE posts.id = ? AND posts.status IN (2)', $id);
		$result = null;
		
		while($row = MF_DB::fetch($query)) {
			if(isset($result)) {
				throw new Exception('Only one post was excepted');
			}
			
			$result = MF_Post::fetch($row);
		}
		
		return $result;			
	}
	
	private static function fetch($row) {
		$post = new MF_Post();
		$post->id = intval($row['id']);
		$post->brandId = intval($row['brand_id']);
		$post->brandName = $row['brand_name'];
		$post->sizeId = intval($row['size_id']);
		$post->sizeName = $row['size_name'];
		$post->condition = intval($row['condition']);
		$post->materials = $row['materials'];
		$post->price = intval($row['price']);
		$post->priceOriginal = intval($row['price_original']);
		$post->currency = $row['currency'];
		$post->title = $row['title'];
		$post->fit = $row['fit'];
		$post->notes = $row['notes'];
		$post->editorial = $row['editorial'];
		
		return $post;
	}
	
	public function media() {
		if($this->_media === null) {
			$this->_media = array();
			$query = MF_DB::query('SELECT * from post_media WHERE post_id = ?', $this->id);
			
			while($row = MF_DB::fetch($query)) {
				$this->_media[] = intval($row['media_id']);
			}
		}
		
		return $this->_media;
	}
}

/* Script */

$id = (isset($_GET['id'])) ? intval($_GET['id']) : null;
$post = ($id != null) ? MF_Post::find($id) : null;

if($post != null) {
	header('HTTP/1.1 200 OK');
	$media = $post->media();
} else {
	header('HTTP/1.1 404 Not Found');
	exit();
}
?>
<html>
	<head>
		<meta name="viewport" content="width=device-width" />
		<meta name="apple-itunes-app" content="app-id=myAppStoreID, app-argument=reloved:post/<?php echo $post->id; ?>" />
		<title><?php echo htmlspecialchars($post->brandName); ?></title>
		<style type="text/css"><!--
			* {
				color: #FFF;
    			font-family: 'HelveticaNeue';
    			font-size: 14px;
			}
			
			a {
				text-decoration: none;
			}
			
			body {
				margin: 0px;
				padding: 0px;
			}
			
			.text {
				vertical-align: middle;
				height: 40px;
				line-height: 22px;
			}
			
			div.container {
				width: 100%;
				max-width: 640px;
				margin: 50px auto 0px auto;
			}
			
			div.envelope {
				position: absolute;
				width: 320px;
				height: 368px;
				overflow: hidden;
			}
			
			div.envelope .background {
				position: absolute;
				left: 0px;
				right: 0px;
				bottom: 0px;
				height: 286px;
				background-image: url('/img/Envelope-Lower.png');
				background-size: 100%;
				background-position: center bottom;
				background-repeat: no-repeat;
			}
			
			div.envelope .contents {
				position: absolute;
				left: 32px;
				right: 32px;
				bottom: 0px;
				top: 0px;
				background: #FFF;
			}
			
			div.envelope .button1 {
				background: #989898;
				position: absolute;
				top: 46px;
				left: 0px;
				right: 50%;
				height: 46px;
				padding: 3px 3px 3px 6px;
				border-right: 1px solid #FFF;
			}
			
			div.envelope .button2 {
				background: #989898;
				position: absolute;
				top: 46px;
				left: 50%;
				right: 0px;
				height: 46px;
				padding: 3px 3px 3px 14px;
			}
			
			div.envelope .image {
				position: absolute;
				left: 0px;
				right: 0px;
				top: 92px;
			}
			
			div.envelope .foreground {
				background-image: url('/img/Envelope-Top.png');
				background-position: center bottom;
				background-size: 100%;
				background-repeat: no-repeat;
				position: absolute;
				left: 0px;
				right: 0px;
				bottom: -1px;
				height: 170px;
			}
			
			body {
				background: #eeeeee;
			}
			
			img {
				width: 100%;
			}
			
			/* Retina */
			@media screen and (-webkit-min-device-pixel-ratio: 1.5) {
    			div.envelope .background {
					background-image: url('/img/Envelope-Lower@2x.png');
				}
				
				div.envelope .foreground {
					background-image: url('/img/Envelope-Top@2x.png');
				}
			}
		--></style>
	</head>
	<body>
		<div class="container">
			<div class="envelope">
				<div class="background"></div>
				<div class="contents">
					<div class="image">
<?php if(count($media) > 0) { ?>
						<img src="http://api.relovedapp.co.uk/media/download/<?php echo $media[0]; ?>?size=i2" width="100%" alt="" />
<?php } ?>
					</div>
					<div class="button1">
						<div class="text">
							<strong><?php echo str_replace(' ', '&nbsp', htmlspecialchars($post->brandName)); ?></strong><br />
							<?php echo str_replace(' ', '&nbsp', 'UK '.htmlspecialchars($post->sizeName).' / &pound;'.htmlspecialchars($post->price / 100)); ?>
						</div>
					</div>
					<div class="button2">
						<div class="text">
							<a href="reloved://post/<?php echo $post->id; ?>">
								<strong>See details</strong><br />
								Opens in App
							</a>
						</div>
					</div>
				</div>
				<div class="foreground"></div>
			</div>
		</div>
	</body>
</html>