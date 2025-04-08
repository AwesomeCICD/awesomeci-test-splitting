<?php
use PHPUnit\Framework\TestCase;
use Demo\File30;

class File30Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File30::add(2, 3));
    }
}
