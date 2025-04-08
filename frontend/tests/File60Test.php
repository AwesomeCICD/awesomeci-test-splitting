<?php
use PHPUnit\Framework\TestCase;
use Demo\File60;

class File60Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File60::add(2, 3));
    }
}
