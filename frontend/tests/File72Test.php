<?php
use PHPUnit\Framework\TestCase;
use Demo\File72;

class File72Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File72::add(2, 3));
    }
}
