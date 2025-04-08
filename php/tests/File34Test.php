<?php
use PHPUnit\Framework\TestCase;
use Demo\File34;

class File34Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File34::add(2, 3));
    }
}
