<?php
use PHPUnit\Framework\TestCase;
use Demo\File74;

class File74Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File74::add(2, 3));
    }
}
