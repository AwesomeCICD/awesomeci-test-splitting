<?php
use PHPUnit\Framework\TestCase;
use Demo\File9;

class File9Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File9::add(2, 3));
    }
}
