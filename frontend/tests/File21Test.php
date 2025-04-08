<?php
use PHPUnit\Framework\TestCase;
use Demo\File21;

class File21Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File21::add(2, 3));
    }
}
