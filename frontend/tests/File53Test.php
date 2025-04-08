<?php
use PHPUnit\Framework\TestCase;
use Demo\File53;

class File53Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File53::add(2, 3));
    }
}
