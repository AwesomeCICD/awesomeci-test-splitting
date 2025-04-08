<?php
use PHPUnit\Framework\TestCase;
use Demo\File70;

class File70Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File70::add(2, 3));
    }
}
