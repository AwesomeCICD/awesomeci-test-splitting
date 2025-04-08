<?php
use PHPUnit\Framework\TestCase;
use Demo\File54;

class File54Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File54::add(2, 3));
    }
}
