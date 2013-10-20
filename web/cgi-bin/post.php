<?php

/* Config */

define('MF_MYSQL_HOST', 'localhost');
define('MF_MYSQL_USER', '');
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
			'SELECT posts.*, brands.name AS brand_name FROM posts '.
				'LEFT JOIN brands ON brands.id = posts.brand_id '.
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
		<title><?php echo htmlspecialchars($post->brandName); ?></title>
		<style type="text/css"><!--
			* {
    			font-family: 'HelveticaNeue';
    			font-size: 14px;
			}
			
			img {
				width: 100%;
				max-width: 640;
			}
		--></style>
	</head>
	<body>
		<h1><?php echo htmlspecialchars($post->brandName); ?></h1>
<?php if(strlen($post->editorial) > 1) { ?>
		<fieldset>
			<legend>Reloved notes</legend>
			<?php echo htmlspecialchars($post->editorial); ?></h1>
		</fieldset>
<?php } ?>
		<fieldset>
			<legend>Title</legend>
			<?php echo htmlspecialchars($post->title); ?></h1>
		</fieldset>
		<fieldset>
			<legend>Materials</legend>
			<?php echo htmlspecialchars($post->materials); ?></h1>
		</fieldset>
		<fieldset>
			<legend>Price</legend>
			<?php echo htmlspecialchars($post->price / 100).' '.htmlspecialchars($post->currency); ?></h1>
		</fieldset>
		<fieldset>
			<legend>Fit</legend>
			<?php echo htmlspecialchars($post->fit); ?></h1>
		</fieldset>
		<fieldset>
			<legend>Notes</legend>
			<?php echo htmlspecialchars($post->notes); ?></h1>
		</fieldset>
<?php foreach($media as $m_) { ?>
		<img src="http://api.relovedapp.co.uk/media/download/<?php echo $m_; ?>?l=t4" alt="" />
<?php } ?>
	</body>
</html>