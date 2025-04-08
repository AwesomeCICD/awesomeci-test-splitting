<?php
use PHPUnit\Framework\TestCase;
use Demo\File6;

class File6Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File6::add(2, 3));
    }
}
