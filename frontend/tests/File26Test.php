<?php
use PHPUnit\Framework\TestCase;
use Demo\File26;

class File26Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File26::add(2, 3));
    }
}
