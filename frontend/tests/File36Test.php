<?php
use PHPUnit\Framework\TestCase;
use Demo\File36;

class File36Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File36::add(2, 3));
    }
}
